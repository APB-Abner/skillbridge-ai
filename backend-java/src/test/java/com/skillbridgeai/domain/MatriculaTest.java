package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class MatriculaTest {

    @Test
    void testConstructorAndGetters() {
        Matricula matricula = new Matricula(1L, 10L, 20L, "ativo", 75.5, 40.0);
        
        assertEquals(1L, matricula.getId());
        assertEquals(10L, matricula.getUsuarioId());
        assertEquals(20L, matricula.getTrilhaId());
        assertEquals("ativo", matricula.getStatus());
        assertEquals(75.5, matricula.getProgressoPct());
        assertEquals(40.0, matricula.getHorasEst());
    }

    @Test
    void testConstructorWithZeroProgress() {
        Matricula matricula = new Matricula(2L, 11L, 21L, "iniciado", 0.0, 0.0);
        
        assertEquals(0.0, matricula.getProgressoPct());
        assertEquals(0.0, matricula.getHorasEst());
    }

    @Test
    void testConstructorWithFullProgress() {
        Matricula matricula = new Matricula(3L, 12L, 22L, "concluido", 100.0, 100.0);
        
        assertEquals(100.0, matricula.getProgressoPct());
        assertEquals(100.0, matricula.getHorasEst());
    }

    @Test
    void testToString() {
        Matricula matricula = new Matricula(1L, 10L, 20L, "ativo", 75.5, 40.0);
        String result = matricula.toString();
        
        assertTrue(result.contains("Matricula"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("usuarioId=10"));
        assertTrue(result.contains("trilhaId=20"));
        assertTrue(result.contains("status=ativo"));
        assertTrue(result.contains("progressoPct=75.5"));
        assertTrue(result.contains("horasEst=40.0"));
    }
}
