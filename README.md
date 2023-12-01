# MC851 - Grupo Popullacho

## Participantes
- Alexandre Ladeira - 212328
- Gabriel Pallotta Cardenete - 216392
- Igor Fernando Mandello - 236769
- Júlia Alves De Arruda - 238077
- Lucas Hideki Carvalho Dinnouti - 220792
- Vinícius Waki Teles - 257390

Placa R4

# Execução

Para executar testes com `iverilog`:
```bash
./test.sh
```

Para simular a execução de um programa presente na pasta `src/resources` com `iverilog`:
```bash
./simulate.sh <programa>
```

Para compilar um programa presente na pasta `compiled/programs` (é necessária a toolchain gnu risc-v ou utilização da imagem docker `compiled/Dockerfile`):
```bash
./compile.sh <programa>
```

Para carregar a síntese do programa na FPGA utilizando o `openFPGALoader` (é necessária a compilação utilizando o Gowin IDE, definindo o programa no arquivo `fpga.v`):
```bash
./program.sh
```

# Diagrama

![arquitetura](https://github.com/lucasdinnouti/MC851/assets/32870665/e791ab5a-f0b6-4139-8b19-5eb72288b701)

# Roteiro

## Etapa 1
- 04/ago: Instalação de software, familiarização com Verilog
- 11/ago: Design dos módulos, pipeline e criação de um ambiente de execução
- 18/ago: Criação de casos de teste e implementação dos módulos e pipeline
- 25/ago: Primeira Entrega 

## Etapa 2
- 01/set: Desesnvolvimento Cache L1 e definição do periférico
- 08/set: Desenvolvimento do periférico e de seu ambiente de execução
- 15/set: Implementeação e execução do periférico em FPGA
- 22/set: Exemplo de código que faça uso do periférico
- 29/set: Segunda Entrega

## Etapa 3
- 06/out: Desenvolvimento do periférico e de seu ambiente de execução
- 13/out: Implementeação e execução do periférico em FPGA
- 20/out: Exemplo de código que faça uso do periférico
- 27/out: Terceira Entrega

## Etapa 4
- 03/nov: TODO
- 10/nov: TODO
- 17/nov: TODO
- 24/nov: TODO
- 01/dez: Entrega Final
