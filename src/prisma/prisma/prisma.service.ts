import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  /// @dev ja habilita a conexao do banco de dados ao iniciar o modulo
  async onModuleInit() {
    await this.$connect();
  }
}
