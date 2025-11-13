package com.skillbridgeai.dao;

import com.skillbridgeai.domain.Usuario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class UsuarioDAOTest {

    private UsuarioDAO usuarioDAO;

    @BeforeEach
    void setUp() {
        usuarioDAO = new UsuarioDAO();
    }

    @Test
    void testSave() {
        Usuario usuario = new Usuario(1L, "João Silva", "joao@example.com", "Desenvolvedor");
        Usuario saved = usuarioDAO.save(usuario);
        
        assertNotNull(saved);
        assertEquals(usuario.getId(), saved.getId());
        assertEquals(usuario.getNome(), saved.getNome());
        assertEquals(usuario.getEmail(), saved.getEmail());
        assertEquals(usuario.getPerfil(), saved.getPerfil());
    }

    @Test
    void testSaveNullUsuario() {
        Usuario saved = usuarioDAO.save(null);
        assertNull(saved);
    }

    @Test
    void testFindById() {
        Optional<Usuario> result = usuarioDAO.findById(1L);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindByIdWithNull() {
        Optional<Usuario> result = usuarioDAO.findById(null);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindAll() {
        List<Usuario> result = usuarioDAO.findAll();
        
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
