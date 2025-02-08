package com.example.todoapp.service;

import com.example.todoapp.model.Task;

import java.util.List;

public interface TaskService {
     List<Task> getAllTasks();
     void createTask(String title);
     void deleteTask(Long id);
     void toggleTask(Long id);
}
