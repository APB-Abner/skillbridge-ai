package br.com.fiap.skillbridge.ai.trilha.service;

import br.com.fiap.skillbridge.ai.shared.exception.NotFoundException;
import br.com.fiap.skillbridge.ai.trilha.dto.TrilhaRequest;
import br.com.fiap.skillbridge.ai.trilha.dto.TrilhaUpdateRequest;
import br.com.fiap.skillbridge.ai.trilha.model.Trilha;
import br.com.fiap.skillbridge.ai.trilha.repository.TrilhaRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TrilhaServiceTest {

    @Mock TrilhaRepository repo;
    @InjectMocks TrilhaService service;

    @Test
    void create_ok(){
        var req = new TrilhaRequest("Java & DDD","Fundamentos", true);
        when(repo.save(any())).thenAnswer(a -> { Trilha t=a.getArgument(0); t.setId(1L); return t; });
        var res = service.create(req);
        assertEquals("Java & DDD", res.titulo());
    }

    @Test
    void get_notFound(){
        when(repo.findById(9L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> service.get(9L));
    }

    @Test
    void delete_notFound(){
        when(repo.existsById(7L)).thenReturn(false);
        assertThrows(NotFoundException.class, () -> service.delete(7L));
    }

    @Test
    void update_ok(){
        var t = Trilha.builder().id(1L).titulo("Old").descricao("D").ativa(true).build();
        when(repo.findById(1L)).thenReturn(Optional.of(t));
        when(repo.save(any())).thenAnswer(a -> a.getArgument(0));

        var res = service.update(1L, new TrilhaUpdateRequest("New","Nova", false));
        assertEquals("New", res.titulo());
        assertFalse(res.ativa());
    }

    @Test
    void list_ok(){
        when(repo.findAll()).thenReturn(java.util.List.of(
                Trilha.builder().id(1L).titulo("X").build(),
                Trilha.builder().id(2L).titulo("Y").build()
        ));
        var out = service.list();
        assertEquals(2, out.size());
    }


}
