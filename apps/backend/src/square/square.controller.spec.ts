import { Test, TestingModule } from '@nestjs/testing';
import { SquareController } from './square.controller';

describe('SquareController', () => {
  let controller: SquareController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SquareController],
    }).compile();

    controller = module.get<SquareController>(SquareController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
