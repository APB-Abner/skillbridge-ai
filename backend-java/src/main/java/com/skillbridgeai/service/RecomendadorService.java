
package com.skillbridgeai.service;

import java.util.*;
import com.skillbridgeai.domain.Recomendacao;

public class RecomendadorService {

  public List<Recomendacao> gerarRecomendacoes(Long usuarioId) {
    // Stub: retornar até 3 recomendações com scoreFit básico
    List<Recomendacao> out = new ArrayList<>();
    for (int i=1; i<=3; i++) {
      out.add(new Recomendacao((long)i, usuarioId, (long)i, Math.max(0.0, 1.0 - (i*0.2))));
    }
    return out;
  }
}
