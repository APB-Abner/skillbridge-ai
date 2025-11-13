
package br.com.fiap.skillbridgeai;

import br.com.fiap.skillbridgeai.service.RecomendadorService;
import br.com.fiap.skillbridgeai.domain.Recomendacao;
import java.util.*;

public class App {
  public static void main(String[] args) {
    RecomendadorService s = new RecomendadorService();
    List<Recomendacao> recs = s.gerarRecomendacoes(1L);
    recs.forEach(r -> System.out.println("Trilha " + r.getTrilhaId() + " fit=" + r.getScoreFit()));
  }
}
