package br.com.fiap.skillbridgeai.domain;

public class Mentoria {
  private Long id;
  private Long usuarioId;
  private String mentor;
  private String status;

  public Mentoria(Long id, Long usuarioId, String mentor, String status) {
    this.id = id;
    this.usuarioId = usuarioId;
    this.mentor = mentor;
    this.status = status;
  }

  public Long getId() { return id; }
  public Long getUsuarioId() { return usuarioId; }
  public String getMentor() { return mentor; }
  public String getStatus() { return status; }

  @Override
  public String toString() {
    return "Mentoria" + "{" + "id=" + id + ", " + "usuarioId=" + usuarioId + ", " + "mentor=" + mentor + ", " + "status=" + status + "}";
  }
}
