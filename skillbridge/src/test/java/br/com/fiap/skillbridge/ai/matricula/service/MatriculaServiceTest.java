package br.com.fiap.skillbridge.ai.matricula.service;

import br.com.fiap.skillbridge.ai.matricula.dto.MatriculaRequest;
import br.com.fiap.skillbridge.ai.matricula.model.Matricula;
import br.com.fiap.skillbridge.ai.matricula.repository.MatriculaRepository;
import br.com.fiap.skillbridge.ai.shared.exception.NotFoundException;
import br.com.fiap.skillbridge.ai.trilha.model.Trilha;
import br.com.fiap.skillbridge.ai.trilha.repository.TrilhaRepository;
import br.com.fiap.skillbridge.ai.user.model.User;
import br.com.fiap.skillbridge.ai.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MatriculaServiceTest {

    @Mock MatriculaRepository repo;
    @Mock UserRepository userRepo;
    @Mock TrilhaRepository trilhaRepo;
    @InjectMocks MatriculaService service;

    @Test
    void create_ok(){
        var req = new MatriculaRequest(1L, 2L);
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("Abner").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(2L)).thenReturn(Optional.of(Trilha.builder().id(2L).titulo("Java").build()));
        when(repo.existsByUser_IdAndTrilha_Id(1L,2L)).thenReturn(false);
        when(repo.save(any())).thenAnswer(a -> { Matricula m=a.getArgument(0); m.setId(10L); return m; });

        var res = service.create(req);
        assertEquals(10L, res.id());
        assertEquals(1L, res.userId());
        assertEquals(2L, res.trilhaId());
    }

    @Test
    void create_userNotFound(){
        var req = new MatriculaRequest(99L, 1L);
        when(userRepo.findById(99L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> service.create(req));
    }

    @Test
    void delete_notFound(){
        when(repo.existsById(77L)).thenReturn(false);
        assertThrows(NotFoundException.class, () -> service.delete(77L));
    }

    @Test
    void create_trilhaNotFound(){
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(9L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> service.create(new MatriculaRequest(1L,9L)));
    }

    @Test
    void create_duplicado_badRequest(){
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(2L)).thenReturn(Optional.of(Trilha.builder().id(2L).titulo("T").build()));
        when(repo.existsByUser_IdAndTrilha_Id(1L,2L)).thenReturn(true);
        assertThrows(IllegalArgumentException.class, () -> service.create(new MatriculaRequest(1L,2L)));
    }

    @Test
    void delete_ok(){
        when(repo.existsById(5L)).thenReturn(true);
        service.delete(5L);
        verify(repo).deleteById(5L);
    }

}
