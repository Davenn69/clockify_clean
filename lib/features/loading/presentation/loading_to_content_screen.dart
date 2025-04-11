import 'package:clockify_miniproject/core/widgets/error_widgets.dart';
import 'package:clockify_miniproject/features/auth/application/providers/password_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/router_constants.dart';
import '../../activity/application/providers/activity_repository_provider.dart';

class LoadingContentScreen extends ConsumerStatefulWidget{
  final Map<String, String> credentials;

  const LoadingContentScreen({super.key, required this.credentials});

  @override
  ConsumerState<LoadingContentScreen> createState() => LoadingContentScreenState();
}

class LoadingContentScreenState extends ConsumerState<LoadingContentScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  String? email;
  String? password;
  bool listenerAdded = false;

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
    email = widget.credentials['email'];
    password = widget.credentials['password'];
    contentReady();
  }

  // @override
  // void didChangeDependencies(){
  //   super.didChangeDependencies();
  //
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //
  //   email = args['email'];
  //   password = args['password'];
  //
  // }

  @override
  Widget build(BuildContext context){
    final saveSessionNotifier = ref.read(saveSessionKeyProvider.notifier);

    if(!listenerAdded){
      listenerAdded = true;
      ref.listen(fetchLoginDataProvider({'email' : email!, 'password' : password!}), (previous, next){
        next.when(
          data : (data){
            if(data['error']=="Unknown error occurred"){
              WidgetsBinding.instance.addPostFrameCallback((_){
                ShowDialog.showErrorDialog(message: data['error']);
              });
              context.pushReplacementNamed(routes.password, extra: email);
            }else if(data['status']=='fail'){
              WidgetsBinding.instance.addPostFrameCallback((_){
                ShowDialog.showErrorDialog(message: data['errors']['message']);
              });
              context.pushReplacementNamed(routes.password, extra: email);
            }else{
              saveSessionNotifier.saveSession(data['token']);
              ref.read(tokenProvider.notifier).state = data['token'];
              context.pushNamed(routes.timer);
              // Navigator.pushReplacementNamed(context, "/content", arguments: {
              //   'token' : data['token']
              // });
            }

          },
          error: (error, stackTrace){
            context.pushReplacementNamed(routes.password);
          },
          loading: (){},
        );
      });
    }

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
                            color: colors.primary,
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