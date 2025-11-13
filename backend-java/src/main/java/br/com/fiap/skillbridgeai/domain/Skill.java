package br.com.fiap.skillbridgeai.domain;

public class Skill {
  private Long id;
  private String nome;
  private String categoria;

  public Skill(Long id, String nome, String categoria) {
    this.id = id;
    this.nome = nome;
    this.categoria = categoria;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public String getCategoria() { return categoria; }

  @Override
  public String toString() {
    return "Skill" + "{" + "id=" + id + ", " + "nome=" + nome + ", " + "categoria=" + categoria + "}";
  }
}
