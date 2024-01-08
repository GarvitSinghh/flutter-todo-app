import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/models/user_model.dart';
import 'package:flutter_todo/screens/hero_screen.dart';
import 'package:flutter_todo/utils/api_service.dart';
import 'package:flutter_todo/utils/http_service.dart';
import 'package:flutter_todo/utils/snackbar.dart';
import 'package:flutter_todo/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  final int userId;
  const TodoScreen({super.key, required this.userId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ApiService service = HttpService();
  User? user;

  // States for Show/Hide completed and Todos
  bool showCompleted = true;
  List<Todo>? todos;

  // TextEditingController for Adding Todos
  final TextEditingController _todoTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch Data and Todos of User.
    _fetchUserData();
    _fetchTodos();
    _todoTitleController.text = '';
  }

  // Fetch user data using the HTTP Service
  Future<void> _fetchUserData() async {
    final response = await service.get(path: '/users/${widget.userId}');
    setState(() {
      user = User.fromJson(json.decode(response.body));
    });
  }

  // Fetch Todos using the HTTP Service
  Future<void> _fetchTodos() async {
    final response = await service.get(path: '/todos/user/${widget.userId}');
    setState(() {
      todos = Todos.fromJson(json.decode(response.body)).todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    // For Responsive Design
    MediaQueryData queryData = MediaQuery.of(context);
    double scaleFactor = queryData.size.height / 820;

    // States
    bool todoLoading = false;
    bool showError = false;
    String errorText = "Error adding Todo!";

    // Key for Opening Scaffold Drawer
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: scaleFactor * 24.0),
            child: FloatingActionButton.small(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              child: (user != null)
                  ? Image.network(user!.image)
                  : const SizedBox(),
            ),
          )
        ],
      ),
      // End Drawer with Logout Functionality
      endDrawer: Drawer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                SizedBox(height: 32 * scaleFactor),
                GestureDetector(
                  onTap: _handleLogout,
                  child: Row(
                    children: [
                      Text("Logout",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24 * scaleFactor)),
                      const Spacer(),
                      IconButton(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout_rounded))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF7F8FA),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            // Bottom Modal for Adding Todo
            showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return SizedBox(
                  height: queryData.size.height * 0.75,
                  width: queryData.size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: scaleFactor * 16.0,
                        vertical: scaleFactor * 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add a task",
                          style: TextStyle(
                            fontSize: scaleFactor * 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 32 * scaleFactor),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              showError
                                  ? Text(
                                      errorText,
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  : const SizedBox(),
                              SizedBox(height: 4.5 * scaleFactor),
                              SizedBox(
                                height: 50 * scaleFactor,
                                width: queryData.size.width * 0.85,
                                child: TextField(
                                  controller: _todoTitleController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: scaleFactor * 16.0,
                                      vertical: scaleFactor * 12.5,
                                    ),
                                    fillColor: Theme.of(context)
                                        .hintColor
                                        .withAlpha(50),
                                    filled: true,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: "Todo Title",
                                    hintStyle: const TextStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24 * scaleFactor),
                        Center(
                          child: SizedBox(
                            height: 50 * scaleFactor,
                            width: queryData.size.width * 0.85,
                            child: CustomButton(
                                text: "Add Todo",
                                color: Colors.black,
                                onpress: () async {
                                  setState(() {
                                    todoLoading = true;
                                  });

                                  if (_todoTitleController.text.isEmpty) {
                                    setState(() {
                                      errorText = 'Todo Title Cannot be Empty!';
                                      showError = true;
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    final response = await service.post(
                                        path: "/todos/add",
                                        body: {
                                          'todo': _todoTitleController.text,
                                          'completed': false,
                                          'userId': widget.userId
                                        });
                                    try {
                                      setState(() {
                                        todos = [
                                          ...todos!,
                                          Todo.fromJson(
                                            json.decode(response.body),
                                          )
                                        ];
                                        showError = false;
                                        _todoTitleController.text = '';
                                        Navigator.of(context).pop();
                                        showSnackBar(context, "Added Todo!",
                                            fromModal: true);
                                      });
                                    } catch (e) {
                                      setState(() {
                                        showError = true;
                                        _todoTitleController.text = '';
                                      });
                                    }
                                  }
                                  setState(() {
                                    todoLoading = false;
                                  });
                                },
                                loading: todoLoading),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            size: 32.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: scaleFactor * 18.0, horizontal: scaleFactor * 18.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Your Tasks:",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: scaleFactor * 32.0),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showCompleted = !showCompleted;
                      });
                    },
                    child: Text(
                      "${showCompleted ? 'Hide' : 'Show'} completed",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: scaleFactor * 15.0,
                          color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: scaleFactor * 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (todos == null)
                        ? [
                            Column(children: [
                              const SizedBox(height: 64),
                              Transform.scale(
                                  scale: 1.5,
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 1.5,
                                  )),
                            ])
                          ]
                        : todos!.map((todo) {
                            if (!showCompleted && todo.completed) {
                              return const SizedBox(); // Return an empty SizedBox if showCompleted is false and the todo is completed
                            } else {
                              return TodoTile(
                                onchange: () {
                                  setState(() {
                                    todo.completed = !todo.completed;
                                  });
                                },
                                onchange2: (bool? val) {
                                  setState(() {
                                    todo.completed = !todo.completed;
                                  });
                                },
                                text: todo.todo,
                                completed: todo.completed,
                                scaleFactor: scaleFactor,
                              );
                            }
                          }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle Logout POST Request
  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HeroScreen()),
        (route) => false);
  }
}

// Component for Tile of Todo Item
class TodoTile extends StatelessWidget {
  final void Function() onchange;
  final void Function(bool?)? onchange2;
  final String text;
  final double scaleFactor;
  final bool completed;
  const TodoTile({
    super.key,
    required this.text,
    required this.onchange,
    required this.onchange2,
    required this.completed,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onchange,
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Transform.scale(
                  scale: 1.25,
                  child: Checkbox(
                    value: completed,
                    onChanged: onchange2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    activeColor: Colors.black,
                    side: const BorderSide(
                      color: Color(0xFFE8E8E8),
                      width: 2.0,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        text,
                        style: TextStyle(
                            fontSize: scaleFactor * 18,
                            color: !completed ? Colors.black54 : Colors.black38,
                            decoration: !completed
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        "${(text.length % 13 + 1).toString().padLeft(2, '0')}:${text.length.toString().padLeft(2, '0')} PM",
                        style: TextStyle(
                          color: !completed ? Colors.black54 : Colors.black38,
                          decoration: !completed
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                          fontSize: scaleFactor * 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
