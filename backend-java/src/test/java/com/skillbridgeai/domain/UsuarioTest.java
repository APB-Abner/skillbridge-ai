package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UsuarioTest {

    @Test
    void testConstructorAndGetters() {
        Usuario usuario = new Usuario(1L, "João Silva", "joao@example.com", "Desenvolvedor");
        
        assertEquals(1L, usuario.getId());
        assertEquals("João Silva", usuario.getNome());
        assertEquals("joao@example.com", usuario.getEmail());
        assertEquals("Desenvolvedor", usuario.getPerfil());
    }

    @Test
    void testConstructorWithNullValues() {
        Usuario usuario = new Usuario(null, null, null, null);
        
        assertNull(usuario.getId());
        assertNull(usuario.getNome());
        assertNull(usuario.getEmail());
        assertNull(usuario.getPerfil());
    }

    @Test
    void testToString() {
        Usuario usuario = new Usuario(1L, "João Silva", "joao@example.com", "Desenvolvedor");
        String result = usuario.toString();
        
        assertTrue(result.contains("Usuario"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("nome=João Silva"));
        assertTrue(result.contains("email=joao@example.com"));
        assertTrue(result.contains("perfil=Desenvolvedor"));
    }

    @Test
    void testToStringWithNullValues() {
        Usuario usuario = new Usuario(null, null, null, null);
        String result = usuario.toString();
        
        assertNotNull(result);
        assertTrue(result.contains("Usuario"));
    }
}
