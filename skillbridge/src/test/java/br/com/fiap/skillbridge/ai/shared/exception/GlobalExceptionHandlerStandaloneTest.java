package br.com.fiap.skillbridge.ai.shared.exception;

import br.com.fiap.skillbridge.ai.trilha.controller.TrilhaController;
import br.com.fiap.skillbridge.ai.trilha.dto.TrilhaRequest;
import br.com.fiap.skillbridge.ai.trilha.service.TrilhaService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(controllers = TrilhaController.class)
class GlobalExceptionHandlerStandaloneTest {

    @Autowired MockMvc mvc;
    @org.springframework.test.context.bean.override.mockito.MockitoBean
    TrilhaService service;

    @Test @DisplayName("PUT /trilhas/{id} - NotFoundException mapeada")
    void update_notFoundException() throws Exception {
        when(service.update(eq(123L), any(TrilhaRequest.class))).thenThrow(new NotFoundException("Trilha não encontrada."));
        mvc.perform(put("/api/v1/trilhas/123")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"titulo\":\"T\",\"descricao\":\"D\"}"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test @DisplayName("PUT /trilhas/{id} - IllegalArgumentException mapeada")
    void update_illegalArgument() throws Exception {
        when(service.update(eq(321L), any(TrilhaRequest.class))).thenThrow(new IllegalArgumentException("Título inválido"));
        mvc.perform(put("/api/v1/trilhas/321")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"titulo\":\"T\",\"descricao\":\"D\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.message").value("Título inválido"));
    }

    @Test @DisplayName("PUT /trilhas/{id} - Exception genérica mapeada")
    void update_genericException() throws Exception {
        when(service.update(eq(999L), any(TrilhaRequest.class))).thenThrow(new RuntimeException("Falha interna"));
        mvc.perform(put("/api/v1/trilhas/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"titulo\":\"T\",\"descricao\":\"D\"}"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.error").value("Internal Server Error"))
                .andExpect(jsonPath("$.message").value("Falha interna"));
    }

    @Test @DisplayName("PUT /trilhas/{id} - validação mapeada (titulo obrigatório)")
    void update_validationException() throws Exception {
        // Request inválida, service nem é chamado -> MethodArgumentNotValidException
        mvc.perform(put("/api/v1/trilhas/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Validation failed"));
    }
}

