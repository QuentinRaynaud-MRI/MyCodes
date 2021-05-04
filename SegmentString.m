function segments=SegmentString(remain,reclvl)

segments = strings(0);
while (remain ~= "")
   [token,remain] = strtok(remain, '\');
   segments = [segments ; token];
end

segments=segments(end-reclvl);
end