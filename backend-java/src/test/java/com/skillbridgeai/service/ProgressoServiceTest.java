package com.skillbridgeai.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ProgressoServiceTest {

    private ProgressoService progressoService;

    @BeforeEach
    void setUp() {
        progressoService = new ProgressoService();
    }

    @Test
    void testCalcularProgressoNormal() {
        double result = progressoService.calcularProgresso(5, 10);
        assertEquals(50.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoZeroModulos() {
        double result = progressoService.calcularProgresso(0, 10);
        assertEquals(0.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoCompleto() {
        double result = progressoService.calcularProgresso(10, 10);
        assertEquals(100.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoTotalZero() {
        double result = progressoService.calcularProgresso(5, 0);
        assertEquals(0.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoTotalNegativo() {
        double result = progressoService.calcularProgresso(5, -10);
        assertEquals(0.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoValoresDecimais() {
        double result = progressoService.calcularProgresso(3.5, 7.0);
        assertEquals(50.0, result, 0.001);
    }

    @Test
    void testCalcularProgressoValoresNegativos() {
        double result = progressoService.calcularProgresso(-5, 10);
        assertEquals(-50.0, result, 0.001);
    }

    @Test
    void testEstimarConclusaoDiasNormal() {
        int result = progressoService.estimarConclusaoDias(10, 70);
        assertEquals(49, result); // 7 weeks = 49 days
    }

    @Test
    void testEstimarConclusaoDiasPoucasHoras() {
        int result = progressoService.estimarConclusaoDias(5, 10);
        assertEquals(14, result); // 2 weeks = 14 days
    }

    @Test
    void testEstimarConclusaoDiasMuitasHoras() {
        int result = progressoService.estimarConclusaoDias(20, 100);
        assertEquals(35, result); // 5 weeks = 35 days
    }

    @Test
    void testEstimarConclusaoDiasHorasSemanaZero() {
        int result = progressoService.estimarConclusaoDias(0, 70);
        assertEquals(Integer.MAX_VALUE, result);
    }

    @Test
    void testEstimarConclusaoDiasHorasSemanaNegativa() {
        int result = progressoService.estimarConclusaoDias(-10, 70);
        assertEquals(Integer.MAX_VALUE, result);
    }

    @Test
    void testEstimarConclusaoDiasCargaZero() {
        int result = progressoService.estimarConclusaoDias(10, 0);
        assertEquals(0, result);
    }

    @Test
    void testEstimarConclusaoDiasCargaNegativa() {
        int result = progressoService.estimarConclusaoDias(10, -20);
        // -20/10 = -2 weeks = -14 days, ceil = -14
        assertEquals(-14, result);
    }

    @Test
    void testEstimarConclusaoDiasValorFracionario() {
        int result = progressoService.estimarConclusaoDias(7.5, 15);
        assertEquals(14, result); // 2 weeks = 14 days
    }

    @Test
    void testEstimarConclusaoDiasArredondamento() {
        int result = progressoService.estimarConclusaoDias(3, 10);
        // 10/3 = 3.33 weeks = 23.33 days, ceil = 24
        assertEquals(24, result);
    }
}
