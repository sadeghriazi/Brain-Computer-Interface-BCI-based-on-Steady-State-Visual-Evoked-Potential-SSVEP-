function resultString = processSignal(signalProcessingBlock)
allPosibleOutputs = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
resultString = allPosibleOutputs(randi(length(allPosibleOutputs)));
end