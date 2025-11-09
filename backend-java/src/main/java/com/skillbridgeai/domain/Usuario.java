package com.skillbridgeai.domain;

public class Usuario {
  private Long id;
  private String nome;
  private String email;
  private String perfil;

  public Usuario(Long id, String nome, String email, String perfil) {
    this.id = id;
    this.nome = nome;
    this.email = email;
    this.perfil = perfil;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public String getEmail() { return email; }
  public String getPerfil() { return perfil; }

  @Override
  public String toString() {
    return "Usuario" + "{" + "id=" + id + ", " + "nome=" + nome + ", " + "email=" + email + ", " + "perfil=" + perfil + "}";
  }
}
