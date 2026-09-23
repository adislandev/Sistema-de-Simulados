import { Navigate, Route, Routes } from "react-router-dom";
import Identificacao from "../features/aluno/Identificacao/Identificacao";
import EscolhaSimulado from "../features/aluno/EscolhaSimulado/EscolhaSimulado";
import Instrucoes from "../features/aluno/Instrucoes/Instrucoes";
import Questao from "../features/aluno/Questao/Questao";
import Resultado from "../features/aluno/Resultado/Resultado";
import Login from "../features/professor/Login/Login";
import Painel from "../features/professor/Painel/Painel";
import RotaProtegida from "../features/professor/RotaProtegida";

export default function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Identificacao />} />
      <Route path="/simulados" element={<EscolhaSimulado />} />
      <Route path="/simulados/:simuladoId/instrucoes" element={<Instrucoes />} />
      <Route path="/simulados/:simuladoId/questao" element={<Questao />} />
      <Route path="/simulados/:simuladoId/resultado" element={<Resultado />} />
      <Route path="/professor/login" element={<Login />} />
      <Route
        path="/professor"
        element={
          <RotaProtegida>
            <Painel />
          </RotaProtegida>
        }
      />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
