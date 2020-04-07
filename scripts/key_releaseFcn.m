function key_releaseFcn
   figure('KeyReleaseFcn',@cb)
      function cb(src,evnt)
      if ~isempty(evnt.Modifier)
         for ii = 1:length(evnt.Modifier)
            out = sprintf('Character: %c\nModifier: %s\nKey: %s\n',...
     evnt.Character,evnt.Modifier{ii},evnt.Key);
            disp(out)
         end
      else
         out = sprintf('Character: %c\nModifier: %s\nKey: %s\n',...
    evnt.Character,'No modifier key',evnt.Key);
         disp(out)
      end
      end 
      end