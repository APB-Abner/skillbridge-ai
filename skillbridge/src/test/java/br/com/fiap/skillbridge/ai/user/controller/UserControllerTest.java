package br.com.fiap.skillbridge.ai.user.controller;

import br.com.fiap.skillbridge.ai.user.dto.UserRequest;
import br.com.fiap.skillbridge.ai.user.dto.UserResponse;
import br.com.fiap.skillbridge.ai.user.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.web.server.ResponseStatusException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(UserController.class)
@AutoConfigureMockMvc(addFilters = false)
class UserControllerTest {

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper om;

    @MockitoBean UserService service;

    @Test
    void create_201() throws Exception {
        var req  = new UserRequest("Abner","abner@fiap.com","12345678901");
        var resp = new UserResponse(1L,"Abner","abner@fiap.com","12345678901");

        when(service.create(any())).thenReturn(resp);

        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(om.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.nome").value("Abner"));
    }

    @Test
    void create_400_bodyVazio() throws Exception {
        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void create_409_duplicado() throws Exception {
        var req = new UserRequest("Abner","abner@fiap.com","12345678901");

        doThrow(new ResponseStatusException(HttpStatus.CONFLICT, "CONFLICT"))
                .when(service).create(any());

        mvc.perform(post("/api/v1/usuarios")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(om.writeValueAsString(req)))
                .andExpect(status().isConflict());
    }

}
