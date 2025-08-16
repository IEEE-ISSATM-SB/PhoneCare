import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable validation pipes
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  const corsOptions: CorsOptions = {
    origin: '*', // Allow all origins for testing purposes
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
  };

  app.enableCors(corsOptions);

  const server = await app.listen(process.env.PORT || 3000);
  server.setTimeout(10000); // Set server timeout to 10 seconds
  
  console.log(`🚀 Backend server running on port ${process.env.PORT || 3000}`);
  console.log(`🔗 Health check: http://localhost:${process.env.PORT || 3000}/health`);
  console.log(`🧪 Test endpoint: http://localhost:${process.env.PORT || 3000}/test`);
}

bootstrap().catch((error) => {
  console.error('❌ Failed to start server:', error);
  process.exit(1);
});
