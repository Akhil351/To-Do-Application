package com.example.todoapp.service.impl;

import com.example.todoapp.model.Task;
import com.example.todoapp.repo.TaskRepo;
import com.example.todoapp.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class TaskServiceImpl implements TaskService {
    @Autowired
    private TaskRepo taskRepo;

    @Override
    public List<Task> getAllTasks() {
        return taskRepo.findAll();
    }

    @Override
    public void createTask(String title) {
        Task task=Task.builder().title(title).completed(false).createdAt(LocalDateTime.now()).build();
        taskRepo.save(task);
    }

    @Override
    public void deleteTask(Long id) {
        taskRepo.deleteById(id);
    }

    @Override
    public void toggleTask(Long id) {
        Task task=taskRepo.findById(id).orElseThrow(()->new IllegalArgumentException("InvalidTask"));
        task.setCompleted(!task.isCompleted());
        taskRepo.save(task);
    }
}
