package br.com.fiap.skillbridgeai.domain;

public class Recomendacao {
  private Long id;
  private Long usuarioId;
  private Long trilhaId;
  private double scoreFit;

  public Recomendacao(Long id, Long usuarioId, Long trilhaId, double scoreFit) {
    this.id = id;
    this.usuarioId = usuarioId;
    this.trilhaId = trilhaId;
    this.scoreFit = scoreFit;
  }

  public Long getId() { return id; }
  public Long getUsuarioId() { return usuarioId; }
  public Long getTrilhaId() { return trilhaId; }
  public double getScoreFit() { return scoreFit; }

  @Override
  public String toString() {
    return "Recomendacao" + "{" + "id=" + id + ", " + "usuarioId=" + usuarioId + ", " + "trilhaId=" + trilhaId + ", " + "scoreFit=" + scoreFit + "}";
  }
}
