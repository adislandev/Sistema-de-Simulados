import ExcelJS from "exceljs";
import type { ResultadoAlunoSimuladoPainel } from "./professorApi";
import type { NotaN1 } from "../types/database";

export async function exportarResultadosXlsx(resultados: ResultadoAlunoSimuladoPainel[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  const planilha = workbook.addWorksheet("Resultados");

  planilha.columns = [
    { header: "Aluno", key: "aluno", width: 28 },
    { header: "Disciplina", key: "disciplina", width: 22 },
    { header: "Simulado", key: "simulado", width: 28 },
    { header: "Tentativa 1", key: "t1", width: 12, style: { numFmt: "0.00" } },
    { header: "Tentativa 2", key: "t2", width: 12, style: { numFmt: "0.00" } },
    { header: "Tentativa 3", key: "t3", width: 12, style: { numFmt: "0.00" } },
    { header: "Média", key: "media", width: 10, style: { numFmt: "0.00" } },
    { header: "Ponto extra", key: "pontoExtra", width: 12, style: { numFmt: "0.00" } },
    { header: "Última tentativa", key: "ultimaTentativa", width: 20, style: { numFmt: "dd/mm/yyyy hh:mm" } },
  ];
  planilha.getRow(1).font = { bold: true };

  for (const r of resultados) {
    const nota = (numero: number) => r.tentativas.find((t) => t.numeroTentativa === numero)?.nota ?? null;
    planilha.addRow({
      aluno: r.alunoNome,
      disciplina: r.disciplinaNome,
      simulado: r.simuladoTitulo,
      t1: nota(1),
      t2: nota(2),
      t3: nota(3),
      media: r.media,
      pontoExtra: r.pontoExtra,
      ultimaTentativa: r.ultimaTentativaEm ? new Date(r.ultimaTentativaEm) : null,
    });
  }

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], {
    type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `resultados-simulados-${new Date().toISOString().slice(0, 10)}.xlsx`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}

export async function exportarNotaN1Xlsx(linhas: NotaN1[], disciplina: string): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  const planilha = workbook.addWorksheet("Nota N1");
  const numero = { numFmt: "0.00" };

  planilha.columns = [
    { header: "RA", key: "ra", width: 12 },
    { header: "Aluno", key: "nome", width: 38 },
    { header: "Turma", key: "turma", width: 12 },
    { header: "Atividades", key: "atividades", width: 12, style: numero },
    { header: "Prova", key: "prova", width: 10, style: numero },
    { header: "Extra (manual)", key: "extra", width: 14, style: numero },
    { header: "Total bruto (sem simulado)", key: "brutoSem", width: 16, style: numero },
    { header: "Nota N1 (sem simulado)", key: "n1Sem", width: 16, style: numero },
    { header: "Ponto do simulado", key: "simulado", width: 14, style: numero },
    { header: "Tentativas do simulado", key: "tentativas", width: 12 },
    { header: "Vínculo do simulado", key: "vinculo", width: 14 },
    { header: "Nota N1 (com simulado)", key: "n1Com", width: 16, style: numero },
    { header: "Excedente (acima de 10)", key: "excedente", width: 14, style: numero },
    { header: "Situação", key: "situacao", width: 16 },
  ];
  planilha.getRow(1).font = { bold: true };

  for (const l of linhas) {
    planilha.addRow({
      ra: l.ra,
      nome: l.nome,
      turma: l.turma,
      atividades: l.atividades_soma,
      prova: l.prova_final,
      extra: l.extra_manual,
      brutoSem: l.total_bruto_sem_simulado,
      n1Sem: l.nota_n1_sem_simulado,
      simulado: l.ponto_simulado,
      tentativas: l.tentativas_validas,
      vinculo: l.vinculo_status,
      n1Com: l.nota_n1_com_simulado,
      excedente: l.excedente_com_simulado,
      situacao: l.situacao,
    });
  }

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], {
    type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `nota-n1-${disciplina.toLowerCase().replace(/[^a-z0-9]+/g, "-")}-${new Date().toISOString().slice(0, 10)}.xlsx`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}
