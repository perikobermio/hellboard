import 'package:flutter/material.dart';

const btAddress = 'C8:F0:9E:75:16:42';
const viasFile  = 'https://hellboard-default-rtdb.firebaseio.com/vias.json';
const usersFile  = 'https://hellboard-default-rtdb.firebaseio.com/users.json';

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

const colors = {
  'v': Color.fromARGB(255, 135, 135, 135),
  'v+': Color.fromARGB(255, 135, 135, 135),
  '6a': Color.fromARGB(255, 255, 240, 31),
  '6a+': Color.fromARGB(255, 255, 240, 31),
  '6b': Color.fromARGB(255, 109, 255, 76),
  '6b+': Color.fromARGB(255, 109, 255, 76),
  '6c': Color.fromARGB(255, 91, 225, 255),
  '6c+': Color.fromARGB(255, 91, 225, 255),
  '7a': Color.fromARGB(255, 255, 149, 1),
  '7a+': Color.fromARGB(255, 255, 149, 1),
  '7b': Color.fromARGB(255, 197, 105, 255),
  '7b+': Color.fromARGB(255, 197, 105, 255),
  '7c': Color.fromARGB(255, 252, 64, 64),
  '7c+': Color.fromARGB(255, 252, 64, 64),
  '8a': Color.fromARGB(255, 50, 50, 50),
  '8a+': Color.fromARGB(255, 50, 50, 50),
  '8b': Color.fromARGB(255, 0, 0, 0),
  '8b+': Color.fromARGB(255, 0, 0, 0),
  '8c': Color.fromARGB(255, 0, 0, 0),
  '8c+': Color.fromARGB(255, 0, 0, 0),
};

const List<Map> viaTools = [
  {
    "id": "done",
    "label": "Eginda"
  },{
    "id": "project",
    "label": "Proiekto"
  },{
    "id": "regrade",
    "label": "Reakota"
  }
];