package com.skillbridgeai.dao;

import java.util.*;
import com.skillbridgeai.domain.Usuario;

public class UsuarioDAO {
  public Usuario save(Usuario e) {
    // TODO: Implementar persistência (stub)
    return e;
  }
  public Optional<Usuario> findById(Long id) {
    return Optional.empty();
  }
  public List<Usuario> findAll() {
    return new ArrayList<>();
  }
}
