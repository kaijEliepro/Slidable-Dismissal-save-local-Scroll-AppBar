import 'package:flutter/material.dart';
import 'package:fluttermestutos/screens/add_task.dart';
import 'package:fluttermestutos/screens/list_task.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  ScrollController _scrollController;
  TabController _tabController;

  @override
  void initState() {
   _scrollController = ScrollController();
   _tabController =TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              title: Text('Task'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text :'List Tasks',
                    icon: Icon(Icons.collections_bookmark),
                  ),
                  Tab(
                    text :'Add Task',
                    icon: Icon(Icons.mode_edit),
                  ),
                ],
                controller: _tabController,
              ),

            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            ListTask(),
            AddTask(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
