import 'package:doc_trial/bloc/home_bloc.dart';
import 'package:doc_trial/bloc/user_bloc.dart';
import 'package:doc_trial/models/screen_argument_model.dart';
import 'package:doc_trial/screens/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    Provider.of<UserBloc>(context, listen: false)
        .assignUserEmail()
        .then((value) {
      Provider.of<HomeBloc>(context, listen: false).getUsers();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        centerTitle: false,
        //tomar en cuenta aca que solo traera el nombre cuando haga login ya que esta logistica normalmente se maneja con
        //shared preferences para almacenar dicha informacion del usuario dentro de la memoria del telefono
        title:  Text('Bienvenid@ ${Provider.of<UserBloc>(context, listen: false).userName},'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            titleRow(context, search),
            const SizedBox(
              height: 15,
            ),
            Provider.of<HomeBloc>(context, listen: true).isUsersLoading
                ? const Text('loading')
                : context.read<HomeBloc>().searchedList.isEmpty
                    ? const Text('No user has been added yet')
                    : userList(context),
          ],
        ),
      ),
    );
  }
}


Widget userList(BuildContext context) {
  return Expanded(
    child: ListView.builder(
      itemCount: context.read<HomeBloc>().searchedList.length,
      itemBuilder: (BuildContext context, int index) {
        if (context.read<HomeBloc>().searchedList[index].email ==
            context.read<UserBloc>().userEmail) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000012).withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: RawMaterialButton(
              onPressed: () => Navigator.pushNamed(context, Routes.chatScreen,
                  arguments: ScreenArguments(
                      context.read<HomeBloc>().searchedList[index].name,
                      additionalArgs:
                          context.read<HomeBloc>().searchedList[index].email)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  title:
                      Text(context.read<HomeBloc>().searchedList[index].name),
                  subtitle:
                      Text(context.read<HomeBloc>().searchedList[index].email),
                  trailing:
                      Text(context.read<HomeBloc>().searchedList[index].age),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget titleRow(BuildContext context, TextEditingController search) {
  return Row(
    children: [
      Text(
        'Contacts',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Expanded(child: Container()),
      const SizedBox(
        width: 10,
      ),
      Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Visibility(
                  visible: context.watch<HomeBloc>().searchButtonActivation
                      ? true
                      : false,
                  child: const SizedBox(
                    width: 10,
                  ),
                ),
                Visibility(
                  visible: context.watch<HomeBloc>().searchButtonActivation
                      ? true
                      : false,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 25,
                      width: 200,
                      child: TextField(
                        onChanged: (string) {
                          context.read<HomeBloc>().setSearchWord(string);
                          if (string.isEmpty) {
                            search.clear();
                          }
                        },
                        controller: search,
                        decoration: const InputDecoration(
                          fillColor: Color(0XFFf4f4f4),
                          filled: true,
                          hintText: 'Buscar...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  constraints: const BoxConstraints(minWidth: 0),
                  onPressed: () {
                    Provider.of<HomeBloc>(context, listen: false)
                        .toggleSearchButton();
                    if (!context.read<HomeBloc>().searchButtonActivation) {
                      context.read<HomeBloc>().setSearchWord('');
                      search.clear();
                    }
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          )),
      const SizedBox(
        width: 5,
      ),
    ],
  );
}
