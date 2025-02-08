package com.example.todoapp.repo;

import com.example.todoapp.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepo extends JpaRepository<Task,Long> {
}
