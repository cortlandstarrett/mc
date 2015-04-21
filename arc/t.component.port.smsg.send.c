    case ${te_c.Name}_${te_po.GeneratedName}_e:
      m->mid.port = ${foreign_te_c.Name}_${foreign_te_po.GeneratedName}_e;
      ${foreign_te_c.Name}_smsg_recv( m );
      break;
