import 'package:flutter/material.dart';

const btAddress     = 'C8:F0:9E:75:16:42';
const viasFile      = 'https://hellboard-default-rtdb.firebaseio.com/blocs.json';
const usersFile     = 'https://hellboard-default-rtdb.firebaseio.com/users.json';
const messagesFile  = 'https://hellboard-default-rtdb.firebaseio.com/messages';
const rtd           = 'https://hellboard-default-rtdb.firebaseio.com/';

const List<Map<String, dynamic>> grades = [
  {'value': '-',    'label': '-'},    {'value': 'V',    'label': 'V'},    {'value': 'V+',    'label': 'V+'},
  {'value': '6a',   'label': '6a'},   {'value': '6a+',   'label': '6a+'}, {'value': '6b',   'label': '6b'},   
  {'value': '6b+',   'label': '6b+'}, {'value': '6c',   'label': '6c'},   {'value': '6c+',   'label': '6c+'}, 
  {'value': '7a',   'label': '7a'},   {'value': '7a+',   'label': '7a+'}, {'value': '7b',   'label': '7b'},   
  {'value': '7b+',   'label': '7b+'}, {'value': '7c',   'label': '7c'},   {'value': '7c+',   'label': '7c+'},
  {'value': '8a',   'label': '8a'},   {'value': '8a+',   'label': '8a+'}, {'value': '8b',   'label': '8b'},   
  {'value': '8b+',   'label': '8b+'}, {'value': '8c',   'label': '8c'},   {'value': '8c+',   'label': '8c+'},
  {'value': '9a',   'label': '9a'},   {'value': '9a+',   'label': '9a+'}, {'value': '9b',   'label': '9b'},   
  {'value': '9b+',   'label': '9b+'}, {'value': '9c',   'label': '9c'},   {'value': '9c+',   'label': '9c+'},
  {'value': '10',   'label': '10'}
];

const List<Map<String, dynamic>> panels = [
  {'value': 'panel40',    'label': '40-ko panela'},
  {'value': 'panel30',    'label': '30-ko panela'},
  {'value': 'panel20a',   'label': '20A-ko panela'},
  {'value': 'panel20b',   'label': '20B-ko panela'}
];

const colors = {
  'v': Color.fromARGB(255, 135, 135, 135),
  'v+': Color.fromARGB(255, 113, 113, 113),
  '6a': Color.fromARGB(255, 144, 255, 74),
  '6a+': Color.fromARGB(255, 59, 153, 0),
  '6b': Color.fromARGB(255, 72, 255, 148),
  '6b+': Color.fromARGB(255, 0, 130, 54),
  '6c': Color.fromARGB(255, 91, 187, 255),
  '6c+': Color.fromARGB(255, 0, 121, 148),
  '7a': Color.fromARGB(255, 195, 97, 255),
  '7a+': Color.fromARGB(255, 157, 0, 255),
  '7b': Color.fromARGB(255, 81, 34, 108),
  '7b+': Color.fromARGB(255, 61, 0, 99),
  '7c': Color.fromARGB(255, 254, 175, 96),
  '7c+': Color.fromARGB(255, 255, 128, 0),
  '8a': Color.fromARGB(255, 255, 110, 110),
  '8a+': Color.fromARGB(255, 255, 0, 0),
  '8b': Color.fromARGB(255, 149, 57, 57),
  '8b+': Color.fromARGB(255, 63, 0, 0),
  '8c': Color.fromARGB(255, 0, 0, 0),
  '8c+': Color.fromARGB(255, 0, 0, 0),
  '9a': Color.fromARGB(255, 0, 0, 0),
  '9a+': Color.fromARGB(255, 0, 0, 0),
  '9b': Color.fromARGB(255, 0, 0, 0),
  '9b+': Color.fromARGB(255, 0, 0, 0),
  '9c': Color.fromARGB(255, 0, 0, 0),
  '9c+': Color.fromARGB(255, 0, 0, 0),
};

const List<Map> viaTools = [
  {
    "id": "edit",
    "label": "Edite"
  },{
    "id": "delete",
    "label": "Borra"
  },{
    "id": "show_user_vies",
    "label": "Egilien blokiek"
  },{
    "id": "show_user_done",
    "label": "Egiliek iniko blokiek"
  },{
    "id": "rate_vie",
    "label": "Puntue"
  }
];