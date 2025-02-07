import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/pages/AttachmentPage.dart';
import 'package:messio/widgets/GradientSnackBar.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 100;
  final Chat chat;

  ChatAppBar(this.chat);

  @override
  _ChatAppBarState createState() => _ChatAppBarState(chat);

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {
  ChatBloc chatBloc;
  Chat chat;
  String _username = "";
  String _name = "";
  Image _image = Image.asset(
    Assets.user,
  );

  _ChatAppBarState(this.chat);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// Text style for everything else

    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (bc, state) {
        if (state is FetchedContactDetailsState) {
          print('Received State of Page');
          print(state.user);
          if (state.username == chat.username) {
            _name = state.user.name;
            _username = '@' + state.user.username;
            _image = Image.network(state.user.photoUrl);
          }
        }
        if (state is PageChangedState) {
          print(state.index);
          print('$_name, $_username');
        }
      },
      child: Material(
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                //adds a shadow to the appbar
                BoxShadow(
                    color: Theme.of(context).hintColor, blurRadius: 2.0, spreadRadius: 0.1)
              ]),
              child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Theme.of(context).primaryColor,
                  child: Row(children: <Widget>[
                    Expanded(
                        //we're dividing the appbar into 7 : 3 ratio. 7 is for content and 3 is for the display picture.
                        flex: 7,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                                flex: 7,
                                child: Container(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.attach_file,
                                                ),
                                                onPressed: () =>
                                                    showAttachmentBottomSheet(
                                                        context)))),
                                    Expanded(
                                        flex: 6,
                                        child: Container(child:
                                            BlocBuilder<ChatBloc, ChatState>(
                                                builder: (context, state) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(_name,
                                                  style: Theme.of(context).textTheme.title),
                                              Text(_username,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle)
                                            ],
                                          );
                                        }))),
                                  ],
                                ))),
                            //second row containing the buttons for media
                            Expanded(
                                flex: 3,
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Text(
                                            'Photos',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.chat.chatId,
                                                      FileType.IMAGE))),
                                        ),
                                        VerticalDivider(
                                          width: 30,
                                          color:Theme.of(context)
                                              .textTheme
                                              .button.color,
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Videos',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.chat.chatId,
                                                      FileType.VIDEO))),
                                        ),
                                        VerticalDivider(
                                          width: 30,
                                          color: Theme.of(context)
                                              .textTheme
                                              .button.color,
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Files',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.chat.chatId,
                                                      FileType.ANY))),
                                        )
                                      ],
                                    ))),
                          ],
                        ))),
                    //This is the display picture
                    Expanded(
                        flex: 3,
                        child: Container(child: Center(child:
                            BlocBuilder<ChatBloc, ChatState>(
                                builder: (context, state) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: _image.image,
                          );
                        })))),
                  ])))),
    );
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Image'),
                    onTap: () => showFilePicker(FileType.IMAGE)),
                ListTile(
                    leading: Icon(Icons.videocam),
                    title: Text('Video'),
                    onTap: () => showFilePicker(FileType.VIDEO)),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text('File'),
                  onTap: () => showFilePicker(FileType.ANY),
                ),
              ],
            ),
          );
        });
  }

  showFilePicker(FileType fileType) async {
    File file = await FilePicker.getFile(type: fileType);
    chatBloc.dispatch(SendAttachmentEvent(chat.chatId, file, fileType));
    Navigator.pop(context);
    GradientSnackBar.showMessage(context, 'Sending attachment..');
  }
}
