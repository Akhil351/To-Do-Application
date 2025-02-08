package com.example.todoapp.controller;

import com.example.todoapp.model.Task;
import com.example.todoapp.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
@RequestMapping
public class TaskController {
    @Autowired
    private TaskService taskService;

    @GetMapping("/tasks")
    public  String getTask(Model model){
        List<Task> tasks=taskService.getAllTasks();
        model.addAttribute("tasks",tasks);
        return "tasks";
    }
    @PostMapping("/task")
    public String createTask(@RequestParam String title){
        taskService.createTask(title);
        return "redirect:/tasks";
    }

    @GetMapping("/{id}/delete")
    public String deleteTask(@PathVariable Long id){
        taskService.deleteTask(id);
        return "redirect:/tasks";
    }

    @GetMapping("/{id}/toggle")
    public String toggleTask(@PathVariable Long id){
        taskService.toggleTask(id);
        return "redirect:/tasks";
    }
}
