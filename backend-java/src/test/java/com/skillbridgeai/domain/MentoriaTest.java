package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class MentoriaTest {

    @Test
    void testConstructorAndGetters() {
        Mentoria mentoria = new Mentoria(1L, 10L, "Dr. Silva", "agendada");
        
        assertEquals(1L, mentoria.getId());
        assertEquals(10L, mentoria.getUsuarioId());
        assertEquals("Dr. Silva", mentoria.getMentor());
        assertEquals("agendada", mentoria.getStatus());
    }

    @Test
    void testConstructorWithNullValues() {
        Mentoria mentoria = new Mentoria(null, null, null, null);
        
        assertNull(mentoria.getId());
        assertNull(mentoria.getUsuarioId());
        assertNull(mentoria.getMentor());
        assertNull(mentoria.getStatus());
    }

    @Test
    void testConstructorWithDifferentStatuses() {
        Mentoria mentoria1 = new Mentoria(1L, 10L, "Mentor A", "agendada");
        Mentoria mentoria2 = new Mentoria(2L, 11L, "Mentor B", "realizada");
        Mentoria mentoria3 = new Mentoria(3L, 12L, "Mentor C", "cancelada");
        
        assertEquals("agendada", mentoria1.getStatus());
        assertEquals("realizada", mentoria2.getStatus());
        assertEquals("cancelada", mentoria3.getStatus());
    }

    @Test
    void testToString() {
        Mentoria mentoria = new Mentoria(1L, 10L, "Dr. Silva", "agendada");
        String result = mentoria.toString();
        
        assertTrue(result.contains("Mentoria"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("usuarioId=10"));
        assertTrue(result.contains("mentor=Dr. Silva"));
        assertTrue(result.contains("status=agendada"));
    }
}
