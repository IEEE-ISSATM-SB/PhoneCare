import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { GoogleStrategy } from './google.strategy';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => {
        const jwtSecret = configService.get<string>('JWT_SECRET');
        const jwtExpiresIn = configService.get<string>('JWT_EXPIRES_IN') || '3600s';
        
        if (!jwtSecret) {
          console.error('❌ JWT_SECRET environment variable is not set!');
          console.error('   Please set JWT_SECRET in your .env file');
          throw new Error('JWT_SECRET environment variable is required');
        }
        
        console.log('🔐 JWT configuration loaded successfully');
        console.log(`   Expires in: ${jwtExpiresIn}`);
        
        return {
          secret: jwtSecret,
          signOptions: { expiresIn: jwtExpiresIn },
        };
      },
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, GoogleStrategy],
})
export class AuthModule {}
