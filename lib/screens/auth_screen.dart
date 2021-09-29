import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/models/http_exption.dart';
import 'package:untitledshopapp/providers/auth.dart';
class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicesize=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0,1],
              )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height:devicesize.height ,
              width:devicesize.width ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.symmetric(vertical:8 ,horizontal: 94),
                        transform: Matrix4.rotationZ(-8*pi/180)..translate( - 10.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0,2),
                            )
                          ]
                        ),
                        child: Text("My Shop",style: TextStyle(color: Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton',

                        ),
                        ),
                      ),
                  ),
                  Flexible(flex: devicesize.width >600? 2:1,child: AuthCard())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode{
  Login,SignUp
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey <FormState> _fromKey=GlobalKey();
  AuthMode _authMode=AuthMode.Login;
  Map<String,String> _authDate={
    'email':'',
    'password':''
  };
  var _isLoading=false ;
  final _passwordController=TextEditingController();
  AnimationController _controller;
  Animation <Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  @override
  void initState() {
   _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 300),);
   _slideAnimation=Tween<Offset>(
     begin: Offset(0,-0.15),
     end: Offset(0,0),
   ).animate(CurvedAnimation(parent: _controller,curve: Curves.fastOutSlowIn

   ),
     );
   _opacityAnimation=Tween<double>(
     begin: 0.0,
     end: 1.0,
   ).animate(CurvedAnimation(parent: _controller,curve: Curves.easeIn

   ),
   );

    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future <void> _submit() async{
    if(!_fromKey.currentState.validate()){
      return;
    }
    FocusScope.of(context).unfocus();
    _fromKey.currentState.save();
    setState(() {
      _isLoading=true ;
    });
    try{
      if(_authMode==AuthMode.Login){
        await Provider.of<Auth>(context,listen: false).login(_authDate['email'], _authDate['password']);
      }
      else{
        await Provider.of<Auth>(context,listen: false).signUp(_authDate['email'], _authDate['password']);
      }
    }
    on HttpExption catch(error){
      var errorExption='Authetiction failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorExption="email is uesd";
      }
     else if(error.toString().contains('INVALID_EMAIL')){
        errorExption="not vaild email";
      }
      else if(error.toString().contains('WEAK_PASSWORD')){
        errorExption="weak password";
      }
      else if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorExption="not found user with email";
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        errorExption="invalid password";
      }
      showErrorDiolag(errorExption);
    }
    catch(error){
      const errorMessage='could not authticat you tyy agin';
      showErrorDiolag(errorMessage);
    }
    setState(() {
      _isLoading=false ;
    });
  }
  void swichAuthMode(){
    if(_authMode==AuthMode.Login){
      setState(() {
        _authMode=AuthMode.SignUp;
      });
      _controller.forward();
    } else{
      setState(() {
        _authMode=AuthMode.Login;
      });
      _controller.reverse();
    }
  }
  void showErrorDiolag(String Message) {
    showDialog(context: context,builder: (ctx)=> AlertDialog(
      title: Text('en eror Occurd'),
      content: Text(Message),
      actions: [
        FlatButton(
            onPressed: ()=> Navigator.of(ctx).pop,
            child: Text('OKEY')
        )

      ],
    )
    );

  }
  @override
  Widget build(BuildContext context) {
    final devicesize=MediaQuery.of(context).size;
    return Card(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode==AuthMode.SignUp? 320:260,
        constraints: BoxConstraints(minHeight:_authMode==AuthMode.SignUp? 320:260),
        width: devicesize.width *0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val){
                    if(val.isEmpty || !val.contains('@')) {
                      return 'Invaild email';
                    } return null;
                  },
                  onSaved: (val){
                    _authDate['email']=val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val){
                    if(val.isEmpty || val.length<5) {
                      return 'Password is too short';
                    } return null;
                  },
                  onSaved: (val){
                    _authDate['password']=val;
                  },
                ),
                AnimatedContainer(constraints: BoxConstraints(
                    minHeight: _authMode==AuthMode.SignUp? 60:0,
                   maxHeight: _authMode==AuthMode.SignUp? 120:0,
                ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(position: _slideAnimation,
                      child:TextFormField(
                        enabled: _authMode ==AuthMode.SignUp,
                        decoration: InputDecoration(labelText: 'confirm Password'),
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        validator:_authMode ==AuthMode.SignUp ? (val){
                          if(val  !=_passwordController.text) {
                            return 'Password do not much';
                          } return null;
                        }:null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if(_isLoading) CircularProgressIndicator(),
                 RaisedButton(
                     child:Text(_authMode==AuthMode.Login ?'Login':'Signup'),
                   onPressed: _submit,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30),
                   ),
                   padding: EdgeInsets.symmetric(horizontal: 30,vertical:8),
                   color: Theme.of(context).primaryColor,
                   textColor: Theme.of(context).primaryTextTheme.headline6.color,
                   ),
                FlatButton(
                    onPressed: swichAuthMode,
                    child: Text('${_authMode==AuthMode.Login ?'Signup':'Login'} INseted'),
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical:4),
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}


