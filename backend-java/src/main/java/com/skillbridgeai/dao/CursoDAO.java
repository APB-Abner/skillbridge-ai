package com.skillbridgeai.dao;

import java.util.*;
import com.skillbridgeai.domain.Curso;

public class CursoDAO {
  public Curso save(Curso e) {
    // TODO: Implementar persistência (stub)
    return e;
  }
  public Optional<Curso> findById(Long id) {
    return Optional.empty();
  }
  public List<Curso> findAll() {
    return new ArrayList<>();
  }
}
