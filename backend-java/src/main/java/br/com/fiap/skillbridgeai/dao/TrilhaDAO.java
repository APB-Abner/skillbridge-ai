package br.com.fiap.skillbridgeai.dao;

import java.util.*;
import br.com.fiap.skillbridgeai.domain.Trilha;

public class TrilhaDAO {
  public Trilha save(Trilha e) {
    // TODO: Implementar persistência (stub)
    return e;
  }
  public Optional<Trilha> findById(Long id) {
    return Optional.empty();
  }
  public List<Trilha> findAll() {
    return new ArrayList<>();
  }
}
