import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String _tablename = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';

  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  save(Task tarefa) async {
    final Database database = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      return await database.insert(
        _tablename,
        taskMap,
      );
    } else {
      return await database.update(
        _tablename,
        taskMap,
        where: '$_name = ?',
        whereArgs: [tarefa.nome],
      );
    }
  }

  Future<List<Task>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> response =
        await database.query(_tablename);
    return toList(response);
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> response = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    return toList(response);
  }

  delete(String nomeDaTarefa) async {
    final Database database = await getDatabase();
    return database.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
  }

  List<Task> toList(List<Map<String, dynamic>> listaDeTarefas) {
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in listaDeTarefas) {
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Map<String, dynamic> toMap(Task tarefa) {
    final Map<String, dynamic> map = {};
    map[_name] = tarefa.nome;
    map[_difficulty] = tarefa.dificuldade;
    map[_image] = tarefa.foto;
    return map;
  }
}
