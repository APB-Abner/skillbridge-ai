package br.com.fiap.skillbridgeai.dao;

import java.util.*;
import br.com.fiap.skillbridgeai.domain.Recomendacao;

public class RecomendacaoDAO {
  public Recomendacao save(Recomendacao e) {
    // TODO: Implementar persistência (stub)
    return e;
  }
  public Optional<Recomendacao> findById(Long id) {
    return Optional.empty();
  }
  public List<Recomendacao> findAll() {
    return new ArrayList<>();
  }
}
