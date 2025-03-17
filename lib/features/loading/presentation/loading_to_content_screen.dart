import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:clockify_miniproject/features/loading/presentation/widgets/loading_to_content_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingContentScreen extends ConsumerStatefulWidget{
  const LoadingContentScreen({super.key});

  @override
  ConsumerState<LoadingContentScreen> createState() => LoadingContentScreenState();
}

class LoadingContentScreenState extends ConsumerState<LoadingContentScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  String? email;
  String? password;

  void contentReady(){
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: -20).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    contentReady();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    email = args['email'];
    password = args['password'];
  }

  @override
  Widget build(BuildContext context){
    final saveSessionNotifier = ref.read(saveSessionKeyProvider.notifier);

    ref.listen(fetchLoginDataProvider({'email' : email!, 'password' : password!}), (previous, next){
      next.when(
        data : (data){
          if(data['status']=='fail'){
            WidgetsBinding.instance.addPostFrameCallback((_){
              showModalLoadingForError(context, data['errors']['message']);

            });
          }else{
            saveSessionNotifier.saveSession(data['token']);
            Navigator.pushReplacementNamed(context, "/content", arguments: {
              'token' : data['token']
            });
          }

        },
        error: (error, stackTrace){
          Navigator.pushReplacementNamed(context, '/password');
        },
        loading: (){},
      );
    });

    return Scaffold(
        body: Center(
          child : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index){
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value * (index + 1) / 1.5),
                      child: Hero(
                        tag: index == 1 ? "animatedBox" : "box$index",
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF233971),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  },
                );
              })
          ),
        )
    );
  }
}