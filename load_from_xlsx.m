function load_from_xlsx(name, sheet)

% load mooring from xlsx

%clear B H Cd moorele ME z U V W rho time

global B H Cd ME moorele z U V W rho time

global ttl

% load the mooring elements

[exist, names] = xlsfinfo (name);
%idx = find(index(sheet, names(:,1)));
[m, idx] = ismember(sheet, names);

[val, txt] = xlsread (name, idx);

ttl=names(idx)

moorele={}

for i=1:length(val)
%  printf('%s, %f\n', T{i+1}, val(i,1))
  
  B(i) = val(i,1);
  
  H(1,i) = val(i,2);
  H(2,i) = val(i,3);
  H(3,i) = val(i,4);
  H(4,i) = val(i,5);
  
  Cd(i) = val(i,6);
  if ~isnan(val(i,7))
    ME(i) = val(i,7);
  else
    ME(i) = Inf;
  end
  moorele{i}=txt{i+1,1};
%  ln = min(16, length(strtrim(txt{i+1})));
%  moorele(i,1:ln) = txt{i+1,1:ln};
end

moorele = char(moorele);

fprintf('Loaded %d elements\n', i)

clear txt val i ln

% load the current profile

[val, txt] = xlsread (name, idx+1);
%clear z U V W rho time

%length(val(:,1))

for i=1:length(val(:,1))
  %printf('%d %f, %f\n', i, val(i,1), val(i,2))
  
  z(i) = val(i,1);
  U(i,1) = val(i,2);
  V(i,1) = val(i,3);
  W(i,1) = val(i,4);
  rho(i,1) = val(i,5);

end

clear txt val i

end
