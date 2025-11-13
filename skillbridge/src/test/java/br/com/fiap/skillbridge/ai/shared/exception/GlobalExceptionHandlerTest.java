package br.com.fiap.skillbridge.ai.shared.exception;

import br.com.fiap.skillbridge.ai.user.controller.UserController;
import br.com.fiap.skillbridge.ai.user.dto.UserRequest;
import br.com.fiap.skillbridge.ai.user.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@AutoConfigureMockMvc(addFilters = false)
@WebMvcTest(UserController.class)
@Import(GlobalExceptionHandler.class)
class GlobalExceptionHandlerTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper om;
    @MockitoBean UserService service;

    @Test
    void notFound_mapeado_404() throws Exception {
        Mockito.when(service.create(any())).thenThrow(new NotFoundException("User not found"));
        String body = om.writeValueAsString(new UserRequest("A","a@a.com","12345678901"));
        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    void validation_400_fieldErrors() throws Exception {
        // email inválido + cpf tamanho errado → Bean Validation
        String body = om.writeValueAsString(new UserRequest("Abner","inv","123"));
        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors").isArray());
    }
}
