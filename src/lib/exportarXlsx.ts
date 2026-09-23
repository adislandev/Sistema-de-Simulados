import ExcelJS from "exceljs";
import type { ResultadoAlunoSimuladoPainel } from "./professorApi";

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
