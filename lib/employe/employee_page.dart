import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'employee_model.dart';


class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<Datum> employees = [];

  Future<List<Datum>> getEmployeApi() async {
    final response = await http.get(
      Uri.parse("https://dummy.restapiexample.com/api/v1/employees"),
    );
    var data = jsonDecode(response.body.toString())['data'];
    if (response.statusCode == 200) {
      for (var a in data) {
        employees.add(Datum.fromJson(a));
      }
      return employees;
    }
    return employees;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee App")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getEmployeApi(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        title: Text(employees[index].employeeName),
                        subtitle: Text(employees[index].employeeAge),
                        trailing: Text(employees[index].employeeSalary),
                        leading: Text(employees[index].id.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
