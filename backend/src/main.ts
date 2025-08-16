import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable validation pipes with more flexible configuration
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: false, // Changed to false to allow extra properties
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
      // Add custom error messages
      exceptionFactory: (errors) => {
        const messages = errors.map(error => {
          const constraints = Object.values(error.constraints || {});
          return `${error.property}: ${constraints.join(', ')}`;
        });
        return new Error(`Validation failed: ${messages.join('; ')}`);
      },
    }),
  );

  const corsOptions: CorsOptions = {
    origin: '*', // Allow all origins for testing purposes
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
  };

  app.enableCors(corsOptions);

  const port = process.env.PORT || 3000;
  const server = await app.listen(port);
  server.setTimeout(10000); // Set server timeout to 10 seconds
  
  console.log(`🚀 Backend server running on http://localhost:${port}`);
  console.log(`🔗 Health check: http://localhost:${port}/health`);
  console.log(`🧪 Test endpoint: http://localhost:${port}/test`);
}

bootstrap().catch((error) => {
  console.error('❌ Failed to start server:', error);
  process.exit(1);
});
