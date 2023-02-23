import '../../Utils/export.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _error="";
  bool login = false;

  _signFirebase()async{

    if (_controllerEmail.text.isNotEmpty) {
      setState(() {
        _error = "";
      });

      try{

        if(login){
          await _auth.signInWithEmailAndPassword(
              email: _controllerEmail.text,
              password: _controllerPassword.text
          ).then((auth)async{
            Future.delayed(Duration.zero,(){
              print("criado usuário");
              FirebaseFirestore.instance.collection('user').doc(auth.user.email).set({
                'email':_controllerEmail.text,
                'senha':_controllerPassword.text
                },SetOptions(merge: true)).then((value) => Navigator.pushReplacementNamed(context, "/home"));

            });
          });
        }else{
          await _auth.createUserWithEmailAndPassword(
              email: _controllerEmail.text,
              password: _controllerPassword.text
          ).then((auth)async{
            FirebaseFirestore.instance.collection('user').doc(auth.user.email).set({
              'email':_controllerEmail.text,
              'senha':_controllerPassword.text
            },SetOptions(merge: true)).then((value) => Navigator.pushReplacementNamed(context, "/home"));
          });
        }

      }on FirebaseAuthException catch (e) {
        if(e.code =="unknown"){
          setState(() {
            _error = "A senha está vazia!";
          });
        }else if(e.code =="invalid-email"){
          setState(() {
            _error = "Digite um e-mail válido!";
          });
        }else if(e.code =="email-already-exists"){
          setState(() {
            _error = "E-mail já esta cadastrado!";
          });
        }else{
          setState(() {
            _error = e.code;
          });
        }
      }
    } else {
      setState(() {
        _error = "Preencha seu email";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/logoMedium.png",width: height*0.3,height: height*0.3),
              SizedBox(height: 10),
              InputRegister(
                width: width*0.8,
                obscure: false,
                controller: _controllerEmail,
                hint: 'Informe seu e-mail',
                fonts: 14,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              InputRegister(
                width: width*0.8,
                obscure: true,
                controller: _controllerPassword,
                hint: 'Informe sua senha',
                fonts: 14,
                keyboardType: TextInputType.visiblePassword,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonsRegister(
                    onTap: ()=>_signFirebase(),
                    text: 'Entrar',
                    color: PaletteColor.blueButton
                ),
              ),
              Text(_error,style: TextStyle(color: Colors.red),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: width*0.2,
                      child: Text('Cadastrar',style: TextStyle(color: Colors.white),)),
                  Switch(value: login, onChanged: (value){
                    setState(() {
                      login = value;
                    });
                  }),
                  Container(
                      width: width*0.2,
                      child: Text('Login',style: TextStyle(color: Colors.white),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
