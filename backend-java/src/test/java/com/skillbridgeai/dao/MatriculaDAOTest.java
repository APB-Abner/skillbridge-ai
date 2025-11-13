package com.skillbridgeai.dao;

import com.skillbridgeai.domain.Matricula;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class MatriculaDAOTest {

    private MatriculaDAO matriculaDAO;

    @BeforeEach
    void setUp() {
        matriculaDAO = new MatriculaDAO();
    }

    @Test
    void testSave() {
        Matricula matricula = new Matricula(1L, 10L, 20L, "ativo", 75.5, 40.0);
        Matricula saved = matriculaDAO.save(matricula);
        
        assertNotNull(saved);
        assertEquals(matricula.getId(), saved.getId());
        assertEquals(matricula.getUsuarioId(), saved.getUsuarioId());
        assertEquals(matricula.getTrilhaId(), saved.getTrilhaId());
        assertEquals(matricula.getStatus(), saved.getStatus());
    }

    @Test
    void testSaveNullMatricula() {
        Matricula saved = matriculaDAO.save(null);
        assertNull(saved);
    }

    @Test
    void testFindById() {
        Optional<Matricula> result = matriculaDAO.findById(1L);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindByIdWithNull() {
        Optional<Matricula> result = matriculaDAO.findById(null);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindAll() {
        List<Matricula> result = matriculaDAO.findAll();
        
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
