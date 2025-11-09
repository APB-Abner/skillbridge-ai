
package com.skillbridgeai;

import com.skillbridgeai.service.RecomendadorService;
import com.skillbridgeai.domain.Recomendacao;
import java.util.*;

public class App {
  public static void main(String[] args) {
    RecomendadorService s = new RecomendadorService();
    List<Recomendacao> recs = s.gerarRecomendacoes(1L);
    recs.forEach(r -> System.out.println("Trilha " + r.getTrilhaId() + " fit=" + r.getScoreFit()));
  }
}
