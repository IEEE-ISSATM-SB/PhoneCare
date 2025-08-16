import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => {
        const mongoUri = configService.get<string>('MONGO_URI');
        
        if (!mongoUri) {
          console.error('❌ MONGO_URI environment variable is not set!');
          console.error('   Please create a .env file with MONGO_URI=mongodb://localhost:27017/phonecare');
          console.error('   Or set the environment variable before starting the server.');
          throw new Error('MONGO_URI environment variable is required');
        }
        
        console.log('🔗 Connecting to MongoDB...');
        console.log(`   URI: ${mongoUri.replace(/\/\/[^:]+:[^@]*@/, '//***:***@')}`);
        
        return {
          uri: mongoUri,
          connectionFactory: (connection) => {
            connection.on('connected', () => {
              console.log('✅ MongoDB connected successfully');
            });
            connection.on('error', (error) => {
              console.error('❌ MongoDB connection error:', error);
            });
            connection.on('disconnected', () => {
              console.log('⚠️ MongoDB disconnected');
            });
            return connection;
          },
        };
      },
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
