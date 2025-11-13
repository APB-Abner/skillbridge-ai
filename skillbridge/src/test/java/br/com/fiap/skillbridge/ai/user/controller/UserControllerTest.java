package br.com.fiap.skillbridge.ai.user.controller;

import br.com.fiap.skillbridge.ai.user.dto.UserRequest;
import br.com.fiap.skillbridge.ai.user.dto.UserResponse;
import br.com.fiap.skillbridge.ai.user.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;

@AutoConfigureMockMvc(addFilters = false)
@WebMvcTest(UserController.class)
class UserControllerTest {

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper om;
    @MockitoBean
    UserService service;

    @Test
    void create_201() throws Exception {
        Mockito.when(service.create(any(UserRequest.class)))
                .thenReturn(new UserResponse(1L,"Abner","abner@fiap.com","12345678901"));

        var body = om.writeValueAsString(new UserRequest("Abner","abner@fiap.com","12345678901"));

        mvc.perform(post("/api/v1/usuarios")
                        .with(csrf()) // <<<<<< ADICIONE ISSO
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.cpf").value("12345678901"));
    }

    @Test
    void create_400_invalidEmail() throws Exception {
        var body = om.writeValueAsString(new UserRequest("Abner","email_invalido","12345678901"));
        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isBadRequest());
    }

    @Test
    void create_400_emailDuplicado() throws Exception {
        Mockito.when(service.create(any())).thenThrow(new IllegalArgumentException("E-mail já cadastrado"));
        var body = om.writeValueAsString(new UserRequest("Abner","abner@fiap.com","12345678901"));
        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isBadRequest());
    }

}
