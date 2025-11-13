package com.skillbridgeai.dao;

import com.skillbridgeai.domain.Trilha;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class TrilhaDAOTest {

    private TrilhaDAO trilhaDAO;

    @BeforeEach
    void setUp() {
        trilhaDAO = new TrilhaDAO();
    }

    @Test
    void testSave() {
        Trilha trilha = new Trilha(1L, "Java Avançado", "Dominar conceitos avançados de Java");
        Trilha saved = trilhaDAO.save(trilha);
        
        assertNotNull(saved);
        assertEquals(trilha.getId(), saved.getId());
        assertEquals(trilha.getNome(), saved.getNome());
        assertEquals(trilha.getObjetivo(), saved.getObjetivo());
    }

    @Test
    void testSaveNullTrilha() {
        Trilha saved = trilhaDAO.save(null);
        assertNull(saved);
    }

    @Test
    void testFindById() {
        Optional<Trilha> result = trilhaDAO.findById(1L);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindByIdWithNull() {
        Optional<Trilha> result = trilhaDAO.findById(null);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindAll() {
        List<Trilha> result = trilhaDAO.findAll();
        
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
